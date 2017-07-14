module Pages.Inquiry exposing (..)

import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form exposing (..)
import Form.Field as Field exposing (Field)
import Types exposing (Taco, Inquiry, Gender(..))
import Components.Bulma as Bulma
import Validators


type alias Model =
    { form : Form String Inquiry
    }


type Msg
    = FormMsg Form.Msg
    | Confirm Inquiry


init : ( Model, Cmd Msg )
init =
    { form = Form.initial initialFields Validators.validateInquiry } ! []


initialFields : List ( String, Field )
initialFields =
    [ ( "gender", Field.string "" )
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormMsg formMsg ->
            case ( formMsg, Form.getOutput model.form ) of
                ( Form.Submit, Just form ) ->
                    ( model, send (Confirm form) )

                _ ->
                    { model | form = Form.update Validators.validateInquiry formMsg model.form } ! []

        _ ->
            model ! []


send : msg -> Cmd msg
send msg =
    Task.succeed msg |> Task.perform identity


view : Taco -> Model -> Html Msg
view taco model =
    Html.map FormMsg (form model)


form : Model -> Html Form.Msg
form { form } =
    let
        genderOptions =
            [ ( "男性", "男性" ), ( "女性", "女性" ), ( "", "回答しない" ) ]

        attrSubmit =
            case Form.getErrors form of
                [] ->
                    []

                _ ->
                    [ disabled True ]
    in
        div [ class "mw8 center f5 f4-ns lh-copy ph1" ]
            [ Bulma.textInput "お名前" (Form.getFieldAsString "name" form)
            , Bulma.emailInput "メールアドレス" (Form.getFieldAsString "email" form)
            , Bulma.emailInput "メールアドレス確認" (Form.getFieldAsString "emailConfirmation" form)
            , Bulma.telInput "お電話番号" (Form.getFieldAsString "phone" form)
            , Bulma.radioInput genderOptions "性別" (Form.getFieldAsString "gender" form)
            , Bulma.textAreaInput "お問合せ内容" (Form.getFieldAsString "content" form)
              --            , Bulma.dangerButton [ onClick <| Form.Reset [] ] [ text "クリア" ]
            , Bulma.primaryButton ([ onClick Form.Submit ] ++ attrSubmit) [ text "確認" ]
            ]
