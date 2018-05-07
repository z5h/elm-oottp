module App exposing (..)

import Json
import Json.Decode as Decode
import Diff
import Ports
import Html exposing (..)
import Essential exposing (Student, Course, Enrollment, EssentialModel)
import View
import AppTypes exposing (..)


main : Program Never Model Message
main =
    Html.program
        { init = init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Message )
init =
    ( initModel, Cmd.none )


strategy : Model -> EssentialModel -> ( Model, Cmd Message )
strategy model newEssentialModel =
    let
        sendUpdateToPort () =
            ( model, Diff.diff model.essential newEssentialModel |> Ports.outgoingModelDiff )

        updateLocalModel () =
            ( { model | essential = newEssentialModel }, Cmd.none )
    in
        sendUpdateToPort ()



-- strategy model newEssentialModel =
--


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    model
        |> addError Nothing
        |> \model ->
            case message of
                Noop ->
                    model ! []

                StudentEmailFieldChange string ->
                    updateUiState (\uiState -> { uiState | studentEmailField = string }) model ! []

                AppTypes.CourseNameFieldChange string ->
                    updateUiState (\uiState -> { uiState | courseNameField = string }) model ! []

                AppTypes.EnrollmentStudendIdFieldChange string ->
                    updateUiState (\uiState -> { uiState | enrollmentStudentIdField = string }) model ! []

                AppTypes.EnrollmentCourseIdFieldChange string ->
                    updateUiState (\uiState -> { uiState | enrollmentCourseIdField = string }) model ! []

                AppTypes.AddStudent ->
                    let
                        newEssentialModelResult =
                            Essential.update model.essential (Essential.NewStudentWithEmail model.uiState.studentEmailField)
                    in
                        case newEssentialModelResult of
                            Result.Ok newEssentialModel ->
                                strategy model newEssentialModel

                            Result.Err error ->
                                (addError (Just error) model) ! []

                AppTypes.AddCourse ->
                    let
                        newEssentialModelResult =
                            Essential.update model.essential (Essential.NewCourseWithName model.uiState.courseNameField)
                    in
                        case newEssentialModelResult of
                            Result.Ok newEssentialModel ->
                                strategy model newEssentialModel

                            Result.Err error ->
                                (addError (Just error) model) ! []

                AppTypes.AddEnrollment ->
                    let
                        result =
                            String.toInt model.uiState.enrollmentStudentIdField
                                |> Result.andThen
                                    (\studentId ->
                                        String.toInt model.uiState.enrollmentCourseIdField
                                            |> Result.andThen
                                                (\courseId ->
                                                    Essential.update model.essential (Essential.Enroll studentId courseId)
                                                )
                                    )
                    in
                        case result of
                            Result.Ok newEssentialModel ->
                                strategy model newEssentialModel

                            Result.Err error ->
                                (addError (Just error) model) ! []

                AppTypes.Patch diff ->
                    { model | essential = Diff.patch model.essential diff } ! []


{-| Set or clear the Error state of the model.
-}
addError : Maybe String -> Model -> Model
addError maybeError model =
    let
        newUiState =
            model.uiState |> \s -> { s | error = maybeError }
    in
        { model | uiState = newUiState }


{-| Update the UIState part of the model.
-}
updateUiState : (UIState -> UIState) -> Model -> Model
updateUiState f model =
    { model | uiState = f model.uiState }


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ Ports.incomingModelPatchPort
            (\value ->
                value
                    |> Decode.decodeValue Json.modelDiffDecoder
                    |> Result.map AppTypes.Patch
                    |> Result.withDefault Noop
            )
        ]
