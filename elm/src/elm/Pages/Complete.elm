module Pages.Complete exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Taco, Inquiry, getItemUrl)
import Components.Bulma as Bulma


view : Taco -> Inquiry -> Html msg
view taco i =
    div [ class "" ]
        [ h1 [] [ text "お問い合わせありがとうございます。" ]
        , h3 [] [ text <| i.name ++ "様" ]
        , (case taco.item |> Maybe.andThen (\item -> getItemUrl item) of
            Just url ->
                Bulma.infoButton [ href url ] [ text "ヤフオクに戻る" ]

            Nothing ->
                text ""
          )
        ]
