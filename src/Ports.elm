port module Ports exposing (outgoingModelDiff, incomingModelPatchPort)

import Json.Decode exposing (Value)
import Diff
import Json


outgoingModelDiff : Diff.ModelDiff -> Cmd msg
outgoingModelDiff =
    Json.encodeModelDiff >> outgoingModelDiffPort


port incomingModelPatchPort : (Value -> msg) -> Sub msg


port outgoingModelDiffPort : Value -> Cmd msg
