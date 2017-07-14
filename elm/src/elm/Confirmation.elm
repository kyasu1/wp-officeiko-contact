module Confirmation exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (Inquiry)


fields : Inquiry -> List ( String, String )
fields inquiry =
    [ ( "お名前", inquiry.name )
    , ( "メールアドレス", inquiry.email )
    , ( "お問合せ内容", inquiry.content )
    ]


view : Inquiry -> Html msg
view inquiry =
    div [] (List.map lineView (fields inquiry))


lineView : ( String, String ) -> Html msg
lineView ( l, v ) =
    article [ class "level" ]
        [ div [ class "level-item has-text-right" ] [ p [ class "title is-5" ] [ text l ] ]
        , div [ class "level-item has-text-left" ] [ p [ class "title is-5" ] [ text v ] ]
        ]
