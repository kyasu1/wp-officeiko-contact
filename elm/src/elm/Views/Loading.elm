module Views.Loading exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> Html msg
view message =
    div [ class "modal is-active" ]
        [ div [ class "modal-background" ] []
        , div [ class "modal-content" ]
            [ div [ id "floatingCirclesG" ]
                [ div [ class "f_circleG", id "frotateG_01" ] []
                , div [ class "f_circleG", id "frotateG_02" ] []
                , div [ class "f_circleG", id "frotateG_03" ] []
                , div [ class "f_circleG", id "frotateG_04" ] []
                , div [ class "f_circleG", id "frotateG_05" ] []
                , div [ class "f_circleG", id "frotateG_06" ] []
                , div [ class "f_circleG", id "frotateG_07" ] []
                , div [ class "f_circleG", id "frotateG_08" ] []
                ]
            , h1 [ class "title is-1 has-text-centered" ] [ text message ]
            ]
        ]
