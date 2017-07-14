module Pages.Confirmation exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation
import Types exposing (Taco, Inquiry, Token, SendMailResponse, getItemUrl)
import Routing.Helpers exposing (Route(InquiryRoute, CompleteRoute), reverseRoute)
import Components.Bulma as Bulma
import RemoteData exposing (WebData, RemoteData(..))
import Api.SendMail
import Views.Loading as Loading


type alias Model =
    { inquiry : Inquiry
    , response : WebData SendMailResponse
    }


type Msg
    = Send Taco
    | Edit
    | HandleSendMailResponse (WebData SendMailResponse)


initialModel : Inquiry -> Model
initialModel inquiry =
    { inquiry = inquiry
    , response = NotAsked
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Edit ->
            ( model, Navigation.newUrl (reverseRoute InquiryRoute) )

        Send taco ->
            ( { model | response = Loading }
            , Api.SendMail.send taco.item model.inquiry taco.token
                |> RemoteData.sendRequest
                |> Cmd.map (HandleSendMailResponse)
            )

        HandleSendMailResponse webData ->
            ( { model | response = webData }, Cmd.none )


view : Taco -> Model -> Html Msg
view taco { inquiry, response } =
    case response of
        NotAsked ->
            div [ class " " ]
                [ h1 [ class "title is-1" ] [ text "内容をご確認の上でご送信ください" ]
                , field (text "お名前") (text <| inquiry.name ++ " 様")
                , field (text "メールアドレス") (text inquiry.email)
                , case inquiry.phone of
                    Nothing ->
                        field (text "お電話番号") (text "未入力")

                    Just phone ->
                        field (text "お電話番号") (text phone)
                , case inquiry.gender of
                    Nothing ->
                        field (text "性別") (text "無回答")

                    Just gender ->
                        field (text "性別") (text <| Types.genderToString gender)
                , field (text "お問い合わせ内容") (text <| inquiry.content)
                , Bulma.dangerButton [ onClick Edit ] [ text "戻って訂正" ]
                , Bulma.primaryButton [ onClick (Send taco) ] [ text "送信" ]
                ]

        Loading ->
            Loading.view "送信中..."

        Failure response ->
            text "FAILURE"

        Success response ->
            div [ class "" ]
                [ h1 [ class "title is-1" ] [ text "お問い合わせありがとうございます。" ]
                , h3 [ class "title is-3" ] [ text <| inquiry.name ++ "様" ]
                , (case taco.item |> Maybe.andThen (\item -> getItemUrl item) of
                    Just url ->
                        Bulma.infoButton [ href url ] [ text "ヤフオクに戻る" ]

                    Nothing ->
                        text ""
                  )
                ]


field : Html msg -> Html msg -> Html msg
field l v =
    div [ class "field" ]
        [ label [ class "label" ] [ l ]
        , p [ class "title is-4" ] [ v ]
        , hr [] []
        ]
