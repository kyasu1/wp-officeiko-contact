module Components.Utils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


buttonFullWidthClass : String -> String
buttonFullWidthClass modifier =
    "button is-outlined is-large is-fullwidth has-text-centered " ++ modifier


baseButton :
    String
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
baseButton c attr elem =
    div [ class "field" ]
        [ p [ class "control" ]
            [ a ([ class <| buttonFullWidthClass c ] ++ attr) elem ]
        ]


primaryButton : List (Attribute msg) -> List (Html msg) -> Html msg
primaryButton attr elem =
    baseButton "is-primary" attr elem


dangerButton : List (Attribute msg) -> List (Html msg) -> Html msg
dangerButton attr elem =
    baseButton "is-danger" attr elem


warningButton : List (Attribute msg) -> List (Html msg) -> Html msg
warningButton attr elem =
    baseButton "is-warning" attr elem
