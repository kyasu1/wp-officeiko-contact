module App exposing (..)

import Task exposing (Task)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Inquiry
import Form
import Item exposing (requestItem)
import Confirmation
import Model exposing (Model, initialModel)
import Types exposing (Item, Inquiry)
import Validators
import Views.Item as Item


init : Maybe String -> ( Model, Cmd Msg )
init itemId =
    let
        model =
            initialModel itemId
    in
        case itemId of
            Just itemId ->
                { model | loading = True } ! [ Task.attempt ReceiveItem (requestItem itemId) ]

            Nothing ->
                model ! []


type Msg
    = RequestItem
    | ReceiveItem (Result Http.Error Item)
    | InquiryMsg Form.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "update" msg of
        ReceiveItem (Ok item) ->
            { model | item = Just item, loading = False } ! []

        ReceiveItem (Err error) ->
            { model | item = Nothing, loading = False } ! []

        InquiryMsg formMsg ->
            case ( formMsg, Form.getOutput model.form ) of
                ( Form.Submit, Just form ) ->
                    { model | inquiry = Just form } ! []

                _ ->
                    { model | form = Form.update Validators.validateInquiry formMsg model.form } ! []

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        content =
            case model.inquiry of
                Nothing ->
                    Html.map InquiryMsg <| Inquiry.view model.form

                Just inquiry ->
                    Confirmation.view inquiry
    in
        div [ class "section" ]
            [ div [ class "container" ]
                [ h1 [ class "title is-1 has-text-centered" ] [ text "お問い合わせフォーム" ]
                , hr [] []
                , div [ class "content" ]
                    [ itemView model
                    , content
                    ]
                ]
            ]


itemView : Model -> Html Msg
itemView model =
    case model.loading of
        True ->
            div [] [ text "読み込み中" ]

        False ->
            Item.view model.item


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
