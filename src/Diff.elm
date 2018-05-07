module Diff exposing (..)

import Essential exposing (Student, Course, Enrollment, EssentialModel)
import ListBackedSet as Set exposing (Set)


type alias Diff a =
    { remove : List a, add : List a }


isEmpty : Diff a -> Bool
isEmpty diff =
    List.isEmpty diff.remove && List.isEmpty diff.add


emptyDiff : Diff a
emptyDiff =
    { remove = [], add = [] }


setDiff : Set a -> Set a -> Diff a
setDiff old new =
    let
        common =
            Set.intersect old new

        added =
            Set.diff new common

        removed =
            Set.diff old common
    in
        { remove = Set.toList removed, add = Set.toList added }


type alias ModelDiff =
    { studentDiff : Diff Student
    , courseDiff : Diff Course
    , enrollmentDiff : Diff Enrollment
    }


{-| Figure out diff between two models. (Note that this generates far from minimal diff.)
-}
diff : EssentialModel -> EssentialModel -> ModelDiff
diff old new =
    ModelDiff
        (setDiff old.students new.students)
        (setDiff old.courses new.courses)
        (setDiff old.enrollments new.enrollments)


patchSet : Set a -> Diff a -> Set a
patchSet set diff =
    let
        setMinusRemoved =
            Set.foldl Set.remove set (Set.fromList diff.remove)

        setMinusRemovedPlusAdd =
            Set.foldl Set.insert setMinusRemoved (Set.fromList diff.add)
    in
        setMinusRemovedPlusAdd


patch : EssentialModel -> ModelDiff -> EssentialModel
patch model modelDiff =
    { students = patchSet model.students modelDiff.studentDiff
    , courses = patchSet model.courses modelDiff.courseDiff
    , enrollments = patchSet model.enrollments modelDiff.enrollmentDiff
    }



--
--
--
