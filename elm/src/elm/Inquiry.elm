module Inquiry exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form exposing (..)
import Form.Field as Field exposing (Field)
import Types exposing (Inquiry, Gender(..))
import Components.Bulma as Bulma


view : Form String Inquiry -> Html Form.Msg
view form =
    let
        genderOptions =
            [ ( "male", "男性" ), ( "female", "女性" ), ( "", "回答しない" ) ]
    in
        div []
            [ Bulma.textInput "お名前" (Form.getFieldAsString "name" form)
            , Bulma.textInput "メールアドレス" (Form.getFieldAsString "email" form)
            , Bulma.textInput "メールアドレス確認" (Form.getFieldAsString "emailConfirmation" form)
            , Bulma.textInput "お電話番号" (Form.getFieldAsString "phone" form)
            , Bulma.radioInput genderOptions "性別" (Form.getFieldAsString "gender" form)
            , Bulma.textAreaInput "お問合せ内容" (Form.getFieldAsString "content" form)
            , p [ class "control" ] [ button [ class "button is-primary", onClick Form.Submit ] [ text "確認" ] ]
            ]


initialFields : List ( String, Field )
initialFields =
    [ ( "email", Field.string "" )
    , ( "emailConfirmation", Field.string "" )
    ]
