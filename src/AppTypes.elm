module AppTypes exposing (..)

import Essential exposing (EssentialModel)
import Diff


type alias UIState =
    { error : Maybe String
    , studentEmailField : String
    , courseNameField : String
    , enrollmentStudentIdField : String
    , enrollmentCourseIdField : String
    }


initUiState : UIState
initUiState =
    { error = Nothing
    , studentEmailField = ""
    , courseNameField = ""
    , enrollmentStudentIdField = ""
    , enrollmentCourseIdField = ""
    }


type alias Model =
    { uiState : UIState
    , essential : EssentialModel
    }


initModel : Model
initModel =
    Model initUiState Essential.emptyModel


type Message
    = Noop
    | StudentEmailFieldChange String
    | CourseNameFieldChange String
    | EnrollmentStudendIdFieldChange String
    | EnrollmentCourseIdFieldChange String
    | AddStudent
    | AddCourse
    | AddEnrollment
    | Patch Diff.ModelDiff
