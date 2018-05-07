module Json exposing (..)

import Essential exposing (Student, Course, Enrollment, EssentialModel)
import Diff exposing (Diff)
import Json.Encode as Encode
import Json.Decode as Decode exposing (Value, Decoder)
import ListBackedSet as Set exposing (Set)


{-| Encode a Student
-}
encodeStudent : Student -> Value
encodeStudent v =
    Encode.object
        [ ( "id", Encode.int v.id )
        , ( "email", Encode.string v.email )
        ]


{-| Decode a Student
-}
studentDecoder : Decoder Student
studentDecoder =
    Decode.map2 Student
        (Decode.field "id" Decode.int)
        (Decode.field "email" Decode.string)


{-| Encode a Course
-}
encodeCourse : Course -> Value
encodeCourse v =
    Encode.object
        [ ( "id", Encode.int v.id )
        , ( "name", Encode.string v.name )
        ]


{-| Decode a Course
-}
courseDecoder : Decoder Course
courseDecoder =
    Decode.map2 Course
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)


{-| Encode an Enrollment
-}
encodeEnrollment : Enrollment -> Value
encodeEnrollment v =
    Encode.object
        [ ( "studentId", Encode.int v.studentId )
        , ( "courseId", Encode.int v.courseId )
        ]


{-| Decode an Enrollment
-}
enrollmentDecoder : Decoder Enrollment
enrollmentDecoder =
    Decode.map2 Enrollment
        (Decode.field "studentId" Decode.int)
        (Decode.field "courseId" Decode.int)


{-| Encode the Essential Model
-}
encodeEssentialModel : EssentialModel -> Value
encodeEssentialModel v =
    Encode.object
        [ ( "students", Encode.list (v.students |> Set.toList |> List.map encodeStudent) )
        , ( "courses", Encode.list (v.courses |> Set.toList |> List.map encodeCourse) )
        , ( "enrollments", Encode.list (v.enrollments |> Set.toList |> List.map encodeEnrollment) )
        ]


{-| Decode the Essential Model
-}
essentialModelDecoder : Decoder EssentialModel
essentialModelDecoder =
    Decode.map3 EssentialModel
        (Decode.field "students" (Decode.list studentDecoder) |> Decode.map Set.fromList)
        (Decode.field "courses" (Decode.list courseDecoder) |> Decode.map Set.fromList)
        (Decode.field "enrollments" (Decode.list enrollmentDecoder) |> Decode.map Set.fromList)


{-| General Diff Encoder
-}
encodeDiff : (a -> Value) -> Diff a -> Value
encodeDiff enc diff =
    Encode.object
        [ ( "remove", Encode.list (diff.remove |> List.map enc) )
        , ( "add", Encode.list (diff.add |> List.map enc) )
        ]


diffDecoder : Decoder a -> Decoder (Diff a)
diffDecoder dec =
    Decode.map2 Diff
        (Decode.field "remove" (Decode.list dec))
        (Decode.field "add" (Decode.list dec))


{-| Model Diff Encoder
-}
encodeModelDiff : Diff.ModelDiff -> Value
encodeModelDiff v =
    Encode.object
        [ ( "studentDiff", encodeDiff encodeStudent v.studentDiff )
        , ( "courseDiff", encodeDiff encodeCourse v.courseDiff )
        , ( "enrollmentDiff", encodeDiff encodeEnrollment v.enrollmentDiff )
        ]


modelDiffDecoder : Decoder Diff.ModelDiff
modelDiffDecoder =
    Decode.map3 Diff.ModelDiff
        (Decode.field "studentDiff" (diffDecoder studentDecoder))
        (Decode.field "courseDiff" (diffDecoder courseDecoder))
        (Decode.field "enrollmentDiff" (diffDecoder enrollmentDecoder))
