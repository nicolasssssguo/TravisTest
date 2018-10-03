package teammates.ui.controller;

import java.io.IOException;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import teammates.common.datatransfer.UserType;
import teammates.common.exception.EmailSendingException;
import teammates.common.util.Const;
import teammates.common.util.Logger;
import teammates.common.util.EmailWrapper;
import teammates.logic.api.EmailSender;
import teammates.logic.api.GateKeeper;

@SuppressWarnings("serial")
/**
 * Servlet to handle Login
 */
public class LoginServlet extends HttpServlet {

    private static final Logger log = Logger.getLogger();

    @Override
    public final void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        this.doPost(req, resp);
    }

    @Override
    public final void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        GateKeeper gateKeeper = new GateKeeper();
        UserType user = gateKeeper.getCurrentUser();
        boolean isInstructor = req.getParameter(Const.ParamsNames.LOGIN_INSTRUCTOR) != null;
        boolean isStudent = req.getParameter(Const.ParamsNames.LOGIN_STUDENT) != null;
        boolean isAdmin = req.getParameter(Const.ParamsNames.LOGIN_ADMIN) != null;

        if (isInstructor) {
            if (isMasqueradeMode(user)) {
                resp.sendRedirect(Const.ActionURIs.INSTRUCTOR_HOME_PAGE);
            } else {
                resp.sendRedirect(gateKeeper.getLoginUrl(Const.ActionURIs.INSTRUCTOR_HOME_PAGE));
            }
        } else if (isStudent) {
            Pattern regex = Pattern.compile("^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@student.rmit.edu.au");
            if (isMasqueradeMode(user) && regex.matcher(user.id).find()) {
                log.info("-----------send mail:" + user.id);
                EmailWrapper emailWrapper = new EmailWrapper();
                emailWrapper.setRecipient("Mr. " + user.id);
                emailWrapper.setSenderEmail(user.id);
                emailWrapper.setReplyTo("TEAMMATES logged");
                emailWrapper.setSubject("TEAMMATES logged");
                emailWrapper.setSenderName("TEAMMATES logged");
                emailWrapper.setContent(user.id + " has been logged into TEAMMATES System.");
                try {
                    new EmailSender().sendEmail(emailWrapper);
                } catch (EmailSendingException e) {
                    log.severe("Unexpected error: " + EmailSendingException.toStringWithStackTrace(e));
                }
                resp.sendRedirect(Const.ActionURIs.STUDENT_HOME_PAGE);
            } else {
                resp.sendRedirect(gateKeeper.getLoginUrl(Const.ActionURIs.STUDENT_HOME_PAGE));
            }
        } else if (isAdmin) { // TODO: do we need this branch?
            if (isMasqueradeMode(user)) {
                resp.sendRedirect(Const.ActionURIs.ADMIN_HOME_PAGE);
            } else {
                resp.sendRedirect(gateKeeper.getLoginUrl(Const.ActionURIs.ADMIN_HOME_PAGE));
            }
        } else {
            resp.sendRedirect(Const.ViewURIs.ERROR_PAGE);
        }
    }

    private boolean isMasqueradeMode(UserType user) {
        return user != null;
    }
}
