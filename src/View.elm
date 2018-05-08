module View exposing (..)

import AppTypes exposing (Message)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Essential exposing (Student, Course, Enrollment)
import ListBackedSet as Set


view : AppTypes.Model -> Html Message
view model =
    div []
        [ div []
            [ header [] [ text "Status" ]
            , text <| (model.uiState.error |> Maybe.withDefault "Ok")
            ]
        , br [] []
        , hr [] []
        , div []
            [ header [] [ text "Students" ]
            , button [ onClick AppTypes.AddStudent ]
                [ text "Add"
                ]
            , input
                [ placeholder "email@domain.com"
                , onInput AppTypes.StudentEmailFieldChange
                , value model.uiState.studentEmailField
                ]
                []
            , dataTable [ "Id", "Email" ] (Set.toList model.essential.students) studentRow
            ]
        , br [] []
        , hr [] []
        , div []
            [ header [] [ text "Courses" ]
            , button [ onClick AppTypes.AddCourse ]
                [ text "Add"
                ]
            , input
                [ placeholder "course name"
                , onInput AppTypes.CourseNameFieldChange
                , value model.uiState.courseNameField
                ]
                []
            , dataTable [ "Id", "Name" ] (Set.toList model.essential.courses) courseRow
            ]
        , br [] []
        , hr [] []
        , div []
            [ header [] [ text "Enrollments" ]
            , button [ onClick AppTypes.AddEnrollment ]
                [ text "Add"
                ]
            , input
                [ placeholder "student id"
                , onInput AppTypes.EnrollmentStudendIdFieldChange
                , value model.uiState.enrollmentStudentIdField
                ]
                []
            , input
                [ placeholder "course id"
                , onInput AppTypes.EnrollmentCourseIdFieldChange
                , value model.uiState.enrollmentCourseIdField
                ]
                []
            , dataTable [ "Student", "Course" ] (Set.toList <| Essential.enrollmentView model.essential) enrollmentRow
            ]
        ]


dataTable : List String -> List a -> (a -> Html Message) -> Html Message
dataTable headers data renderer =
    table [] <|
        [ tr [] (headers |> List.map (\header -> th [] [ text header ])) ]
            ++ List.map renderer data


courseRow : Course -> Html Message
courseRow course =
    tr []
        [ td [] [ text <| toString <| course.id ]
        , td [] [ text <| toString <| course.name ]
        ]


studentRow : Student -> Html Message
studentRow student =
    tr []
        [ td [] [ text <| toString <| student.id ]
        , td [] [ text <| toString <| student.email ]
        ]


enrollmentRow : ( Student, Course ) -> Html Message
enrollmentRow ( student, course ) =
    tr []
        [ td [] [ text <| toString <| student.email ]
        , td [] [ text <| toString <| course.name ]
        ]
