module SharedStyles exposing (..)

import Html.CssHelpers exposing (withNamespace)


type CssIds
    = ItemImage


type CssClasses
    = ItemLabel
    | ItemValue


inquiryNamespace =
    withNamespace "inquiry-"
