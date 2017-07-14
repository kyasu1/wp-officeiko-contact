module Views.Error exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : List (Html msg) -> Html msg
view nodes =
    div [] nodes
