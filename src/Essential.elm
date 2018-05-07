module Essential exposing (..)

import ListBackedSet as Set exposing (Set, isEmpty, filter)


-- Types


type alias StudentId =
    Int


type alias CourseId =
    Int


type alias Student =
    { id : StudentId, email : String }


type alias Course =
    { id : CourseId, name : String }


type alias Enrollment =
    { studentId : StudentId, courseId : CourseId }


type alias EssentialModel =
    { students : Set Student
    , courses : Set Course
    , enrollments : Set Enrollment
    }


emptyModel : EssentialModel
emptyModel =
    { students = Set.empty
    , courses = Set.empty
    , enrollments = Set.empty
    }


enrollmentView : EssentialModel -> Set ( Student, Course )
enrollmentView essentialModel =
    Set.product essentialModel.students essentialModel.courses
        |> Set.product essentialModel.enrollments
        |> Set.filter
            (\( enrollment, ( student, course ) ) ->
                enrollment.studentId
                    == student.id
                    && enrollment.courseId
                    == course.id
            )
        |> Set.map
            (\( enrollment, ( student, course ) ) ->
                ( student, course )
            )



-- Messages


type Message
    = NewStudentWithEmail String
    | NewCourseWithName String
    | Enroll StudentId CourseId



-- helper functions required for core logic and to help maintan model integrity


notEmpty : Set a -> Bool
notEmpty =
    isEmpty >> not


nextStudentId : EssentialModel -> StudentId
nextStudentId model =
    model.students |> Set.map (\{ id } -> id) |> Set.foldr max 0 |> (+) 1


nextCourseId : EssentialModel -> CourseId
nextCourseId model =
    model.courses |> Set.map (\{ id } -> id) |> Set.foldr max 0 |> (+) 1


update : EssentialModel -> Message -> Result String EssentialModel
update model message =
    case message of
        NewStudentWithEmail email ->
            if
                model.students
                    |> filter (\student -> student.email == email)
                    |> notEmpty
            then
                Result.Err <| "Student with Email " ++ email ++ " already exists"
            else
                Result.Ok
                    { model
                        | students = Set.insert (Student (nextStudentId model) email) model.students
                    }

        NewCourseWithName name ->
            if
                model.courses
                    |> filter (\course -> course.name == name)
                    |> notEmpty
            then
                Result.Err <| "Course with Name " ++ name ++ " already exists "
            else
                Result.Ok
                    { model
                        | courses = Set.insert (Course (nextCourseId model) name) model.courses
                    }

        Enroll studentId courseId ->
            if Set.member (Enrollment studentId courseId) model.enrollments then
                Result.Err "Student already enrolled."
            else if not <| Set.member studentId (model.students |> Set.map .id) then
                Result.Err "No such student."
            else if not <| Set.member courseId (model.courses |> Set.map .id) then
                Result.Err "No such course."
            else
                Result.Ok
                    { model
                        | enrollments = Set.insert (Enrollment studentId courseId) model.enrollments
                    }
