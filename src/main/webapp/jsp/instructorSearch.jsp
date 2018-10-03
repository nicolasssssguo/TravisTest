<%@ page trimDirectiveWhitespaces="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="teammates.common.util.FrontEndLibrary" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
<%@ taglib tagdir="/WEB-INF/tags/instructor" prefix="ti" %>
<%@ taglib tagdir="/WEB-INF/tags/instructor/search" prefix="search" %>
<%@ taglib tagdir="/WEB-INF/tags/shared" prefix="shared" %>

<c:set var="jsIncludes">
  <script type="text/javascript" src="<%= FrontEndLibrary.JQUERY_HIGHLIGHT %>"></script>
  <script type="text/javascript" src="/js/instructorSearch.js"></script>
  <script type="text/javascript" src="/js/jquery.form.js"></script>
  <script type="text/javascript" src="/js/jquery.pagination.js"></script>
  <style>
    .m-style {
      position: relative;
      text-align: center;
      zoom: 1;
      padding: 10px;
    }

    .m-style:before,
    .m-style:after {
      content: "";
      display: table;
    }

    .m-style:after {
      clear: both;
      overflow: hidden;
    }

    .m-style span {
      float: left;
      margin: 0 5px;
      width: 38px;
      height: 38px;
      line-height: 38px;
      color: #bdbdbd;
      font-size: 14px;
    }

    .m-style .active {
      float: left;
      margin: 0 5px;
      width: 38px;
      height: 38px;
      line-height: 38px;
      background: #e91e63;
      color: #fff;
      font-size: 14px;
      border: 1px solid #e91e63;
    }

    .m-style a {
      float: left;
      margin: 0 5px;
      width: 38px;
      height: 38px;
      line-height: 38px;
      background: #fff;
      border: 1px solid #ebebeb;
      color: #bdbdbd;
      font-size: 14px;
    }

    .m-style a:hover {
      color: #fff;
      background: #e91e63;
    }

    .m-style .next,
    .m-style .prev {
      font-family: "Simsun";
      font-size: 16px;
      font-weight: bold;
    }

    .now,
    .count {
      padding: 0 5px;
      color: #f00;
    }

    .eg img {
      max-width: 800px;
      min-height: 500px;
    }

    .m-style input {
      float: left;
      margin: 0 5px;
      width: 38px;
      height: 38px;
      line-height: 38px;
      text-align: center;
      background: #fff;
      border: 1px solid #ebebeb;
      outline: none;
      color: #bdbdbd;
      font-size: 14px;
    }
    .select{
      width: 150px;
      height: 40px;
      border-radius: 5px;
      box-shadow: 0 0 5px #ccc;
      position: relative;
      margin: 15px;
    }
    .select select{
      border: none;
      outline: none;
      width: 100%;
      height: 40px;
      line-height: 40px;
      appearance: none;
      -webkit-appearance: none;
      -moz-appearance: none;
      text-align: center;
      text-align-last: center;
    }
  </style>
</c:set>

<ti:instructorPage title="Search" jsIncludes="${jsIncludes}">

  <search:searchPageInput />
  <br>
  <t:statusMessage statusMessagesToUser="${data.statusMessagesToUser}" />
  <div class="panel panel-primary" id="questions">
    <div class="panel-heading">
      <strong>
        Questions, responses, comments on responses
      </strong>
    </div>
    <div class="select">
      <select id="questions_num">
        <option value="1">1 num</option>
        <option value="20">20 num</option>
      </select>
    </div>
    <div id="questions_list" style="padding: 0 15px;">
    </div>
    <div class="m-style" id="questions_page"></div>
  </div>
  <br>
  <div class="panel panel-primary" id="student">
    <div class="panel-heading">
      <strong><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">
        Students
      </font></font></strong>
    </div>
    <div class="select">
      <select id="student_num">
        <option value="10">10 num</option>
        <option value="20">20 num</option>
      </select>
    </div>
    <div id="student_list" style="padding: 0 15px;">
    </div>
    <div class="m-style" id="student_page"></div>
  </div>
</ti:instructorPage>

<script type="text/javascript">
    var studentList = [];
    var questionList = [];
    var studentsData = [];
    var questionsData = [];
    $(function () {
        $("#questions_num").change(function(){

            page(questionList, 1);
        });$("#student_num").change(function(){

            page(studentList, 0);
        });

        if ($('#searchBox').val()) {

            ajaxForm();
        }
        $('#student').hide();
        $('#questions').hide();
    })



    function  ajaxForm() {
        $('#ajax_from').ajaxSubmit({
            success: function(data) {
                if (data.searchStudentsTables.length !== 0) {
                    studentList = data.searchStudentsTables;
                    page(data.searchStudentsTables, 0);
                    $('#statusMessagesToUser').hide();
                } else {
                    $('#student').hide();
                    $('#statusMessagesToUser').show();
                }
                if (data.searchFeedbackSessionDataTables[0].feedbackSessionRows.length !== null) {
                    questionList = data.searchFeedbackSessionDataTables[0].feedbackSessionRows;
                    page(data.searchFeedbackSessionDataTables[0].feedbackSessionRows, 1);
                    $('#statusMessagesToUser').hide();
                } else {
                    $('#student').hide();
                    $('#statusMessagesToUser').show();
                }
            }
        });
        return false;
    }


    function page(data, types) {
        if (data.length === 0) return;
        var pageNum = 0;
        if (types === 0) {
            pageNum = $('#student_num option:selected') .val();
        } else {
            pageNum = $('#questions_num option:selected') .val();
            console.log($('#questions_num option:selected') .val());
        }
        var count = Math.ceil(data.length / pageNum);
        var newData = [];

        for (var i = 0; i < count; i++ ) {
            newData[i] = [];
            var start = i * pageNum;
            var end = (start + pageNum) >  data.length ? data.length : (start + pageNum);
            for (var y = start; y < end; y++) {
                newData[i].push(data[y]);
            }
        }
        if (types === 0) {
            studentsData = newData;
            $('#student_page').html('');
            $('#student_page').pagination({
                pageCount: count,
                jump: true,
                coping: true,
                homePage: 'home',
                endPage: 'last',
                prevContent: 'prev',
                nextContent: 'next',
                jumpBtn: 'go',
                callback: function (api) {
                    studentsHtml(studentsData[api.getCurrent() - 1]);
                }
            });
            studentsHtml(studentsData[0]);
        } else{
            questionsData = newData;
            $('#questions_page').html('');
            $('#questions_page').pagination({
                pageCount: count,
                jump: true,
                coping: true,
                homePage: 'home',
                endPage: 'last',
                prevContent: 'prev',
                nextContent: 'next',
                jumpBtn: 'go',
                callback: function (api) {
                    questionsHtml(questionsData[api.getCurrent() - 1]);
                }
            });
            questionsHtml(questionsData[0]);
        }
    }


    function studentsHtml(data) {
        $('#student_list').html('');
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            var main = document.createElement('div');
            main.className = 'panel panel-info';
            $(main).append('<div class="panel-heading"><strong>['+ item.courseId +']</strong></div>')
            var content = document.createElement('div');
            content.className = 'panel-body padding-0';
            var sections = item.sections;
            for (var s = 0; s < sections.length; s++) {
                var section = sections[s];
                var teams = section.teams;
                for (var t  = 0; t < teams.length; t++){
                    var team = teams[t];
                    var students = team.students;
                    for (var stu = 0; stu < students.length; stu++) {
                        var student = students[stu];
                        $(content).append('<table class="table table-bordered table-striped table-responsive margin-0">\n' +
                            '      <thead class="background-color-medium-gray text-color-gray font-weight-normal">\n' +
                            '        <tr id="resultsHeader-'+ i +'">\n' +
                            '          <th>Photo</th>\n' +
                            '          <th id="button_sortsection-'+ i +'" class="toggle-sort button-sort-none">\n' +
                            '            Section <span class="icon-sort unsorted"></span>\n' +
                            '          </th>\n' +
                            '          <th id="button_sortteam-'+ i +'" class="button-sort-none toggle-sort">\n' +
                            '            Team <span class="icon-sort unsorted"></span>\n' +
                            '          </th>\n' +
                            '          <th id="button_sortstudentname-'+ i +'" class="button-sort-none toggle-sort">\n' +
                            '            Student Name <span class="icon-sort unsorted"></span>\n' +
                            '          </th>\n' +
                            '          <th id="button_sortstudentstatus" class="button-sort-none toggle-sort">\n' +
                            '            Status <span class="icon-sort unsorted"></span>\n' +
                            '          </th>\n' +
                            '          <th id="button_sortemail-'+ i +'" class="button-sort-none toggle-sort">\n' +
                            '            Email <span class="icon-sort unsorted"></span>\n' +
                            '          </th>\n' +
                            '          <th>Action(s)</th>\n' +
                            '        </tr>\n' +
                            '      </thead>\n' +
                            '      <tbody>\n' +
                            '        <tr class="student_row" id="student-c0.0">\n' +
                            '          <td id="studentphoto-c0.0">\n' +
                            '            <div class="profile-pic-icon-click align-center" data-link="">\n' +
                            '              <img src="'+ student.photoUrl +'" alt="No Image Given">\n' +
                            '            </div>\n' +
                            '          </td>\n' +
                            '          <td id="studentsection-c0.0">\n' +
                            '             '+  section.sectionName +'</td>\n' +
                            '          <td id="studentteam-c0.0.0">\n' +
                            '            '+ team.teamName +'</td>\n' +
                            '          <td id="studentname-c0.0">\n' +
                            '            '+ student.studentName +'</td>\n' +
                            '          <td class="align-center">\n' +
                            '            '+ student.studentStatus +'</td>\n' +
                            '          <td id="studentemail-c0.0">\n' +
                            '            '+ student.studentEmail +'</td>\n' +
                            '          <td class="no-print align-center">\n' +
                            '            <a class="btn btn-default btn-xs margin-bottom-7px" title="" href="'+ student.courseStudentDetailsLink +'"\n' +
                            '              target="_blank" rel="noopener noreferrer" data-toggle="tooltip" data-placement="top" data-original-title="View the details of the student">\n' +
                            '              View\n' +
                            '            </a>\n' +
                            '            <a class="btn btn-default btn-xs margin-bottom-7px" title="" href="'+ student.courseStudentEditLink +'"\n' +
                            '              target="_blank" rel="noopener noreferrer" data-toggle="tooltip" data-placement="top" data-original-title="Use this to edit the details of this student. <br>To edit multiple students in one go, you can use the enroll page: <br>Simply enroll students using the updated data and existing data will be updated accordingly">\n' +
                            '              Edit\n' +
                            '            </a>\n' +
                            '            <a class="course-student-delete-link btn btn-default btn-xs margin-bottom-7px" data-student-name="Alice Betsy"\n' +
                            '              data-course-id="375281809.qq.-demo" title="" href="'+ student.courseStudentDeleteLink +'"\n' +
                            '              data-toggle="tooltip" data-placement="top" data-original-title="Delete the student and the corresponding submissions from the course">\n' +
                            '              Delete\n' +
                            '            </a>\n' +
                            '            <a class="btn btn-default btn-xs margin-bottom-7px" href="'+ student.courseStudentRecordsLink +'"\n' +
                            '              title="" target="_blank" rel="noopener noreferrer" data-toggle="tooltip" data-placement="top"\n' +
                            '              data-original-title="View all data about this student">\n' +
                            '              All Records\n' +
                            '            </a>\n' +
                            '          </td>\n' +
                            '        </tr>\n' +
                            '      </tbody>\n' +
                            '    </table>');
                    }
                }
            }
            $(main).append(content);
            $('#student_list').append(main);
        }
        $('#student').show();
    }


    function questionsHtml(data) {
        $('#questions_list').html('');
        for (var r = 0; r < data.length; r++) {
            var feedbackSessionRow = data[r];
            var questionTables = feedbackSessionRow.questionTables;
            var main = document.createElement('div');
            main.className = 'panel-body';
            var rowDiv = document.createElement('div');
            rowDiv.className = 'row';
            $(rowDiv).append('<div class="col-md-2"><strong>'+ feedbackSessionRow.feedbackSessionName +' ('+ feedbackSessionRow.courseId +')</strong></div>');
            var content = document.createElement('div');
            content.className = 'col-md-10';
            for (var q = 0; q < questionTables.length; q++) {
                var questionTable = questionTables[q];
                var questionTableDiv = document.createElement('div');
                questionTableDiv.className = 'panel panel-info';
                $(questionTableDiv).append('<div class="panel-heading"><b>Question '+ questionTable.questionNumber +'</b>: '+ questionTable.questionText +'</div>');
                var responseRows = questionTable.responseRows;
                for (var row = 0; row < responseRows.length; row++) {
                    var responseRow = responseRows[row];
                    var table = document.createElement('table');
                    table.className = 'table';
                    var tbody = document.createElement('tbody');
                    $(tbody).append('<tr><td><b>From:</b> '+ responseRow.giverName +'<b>To:</b> '+ responseRow.recipientName +'</td></tr><tr><td><strong>Response:</strong> '+ responseRow.response +'</td></tr>');
                    var feedbackResponseComments = responseRow.feedbackResponseComments;
                    for (var c = 0; c < feedbackResponseComments.length; c++) {
                        var feedbackResponseComment = feedbackResponseComments[c];
                        $(tbody).append(' <tr>\n' +
                            '                <td>\n' +
                            '                  <ul class="list-group comments" id="responseCommentTable-1-1-1">\n' +
                            '\n' +
                            '                    <li class="list-group-item list-group-item-warning" id="responseCommentRow-1-1-1-1">\n' +
                            '                      <div id="commentBar-1-1-1-1" class="row">\n' +
                            '                        <div class="col-xs-10">\n' +
                            '                          <span class="text-muted">\n' +
                            '                            From: '+ feedbackResponseComment.commentGiverName +' ['+ feedbackResponseComment.createdAt +'] </span>\n' +
                            '                          <span class="glyphicon glyphicon-eye-open" data-toggle="tooltip" data-placement="top" style="margin-left: 5px;"\n' +
                            '                            title="" data-original-title="This response comment is visible to response giver, response recipient, response recipient\'s team, and instructors"></span>\n' +
                            '                        </div>\n' +
                            '                        <div class="col-xs-2">\n' +
                            '                        </div>\n' +
                            '                      </div>\n' +
                            '                      <div id="plainCommentText-1-1-1-1" style="margin-left: 15px;">'+ feedbackResponseComment.commentText +'</div>\n' +
                            '                    </li>\n' +
                            '                  </ul>\n' +
                            '                </td>\n' +
                            '              </tr>')
                    }
                    $(table).append(tbody);
                }
                $(questionTableDiv).append(table);
            }
            $(content).append(questionTableDiv);
            $(rowDiv).append(content);
            $(main).append(rowDiv);
            $('#questions_list').append(main);
        }
        $('#questions').show();
    }

</script>