module Routing.Router exposing (..)

import Navigation exposing (Location)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Routing.Helpers exposing (Route(..), parseLocation, reverseRoute)
import Pages.Inquiry as Inquiry
import Pages.Confirmation as Confirmation
import Pages.Complete as Complete
import Types exposing (Taco, TacoUpdate(..))
import Views.Item as Item
import Slider


type alias Model =
    { inquiryModel : Inquiry.Model
    , confirmationModel : Maybe Confirmation.Model
    , sliderModel : Slider.State
    , route : Route
    }


type Msg
    = UrlChange Location
    | NavigateTo Route
    | InquiryMsg Inquiry.Msg
    | ConfirmationMsg Confirmation.Msg
    | SliderAction Slider.Action


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( inquiryModel, inquiryCmd ) =
            Inquiry.init
    in
        { inquiryModel = inquiryModel
        , confirmationModel = Nothing
        , sliderModel = Slider.initialState
        , route = parseLocation location
        }
            ! [ Cmd.map InquiryMsg inquiryCmd ]


update : Msg -> Model -> ( Model, Cmd Msg, TacoUpdate )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | route = parseLocation location }, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Navigation.newUrl (reverseRoute route), NoUpdate )

        InquiryMsg inquiryMsg ->
            updateInquiry model inquiryMsg

        ConfirmationMsg confirmationMsg ->
            updateConfirmation model confirmationMsg

        SliderAction action ->
            ( { model | sliderModel = Slider.moveImage action model.sliderModel }, Cmd.none, NoUpdate )


updateInquiry : Model -> Inquiry.Msg -> ( Model, Cmd Msg, TacoUpdate )
updateInquiry model inquiryMsg =
    case inquiryMsg of
        Inquiry.Confirm form ->
            ( { model | confirmationModel = Just (Confirmation.initialModel form) }
            , Navigation.newUrl (reverseRoute ConfirmationRoute)
            , NoUpdate
            )

        _ ->
            let
                ( nextInquiryModel, inquiryCmd ) =
                    Inquiry.update inquiryMsg model.inquiryModel
            in
                ( { model | inquiryModel = nextInquiryModel }
                , Cmd.map InquiryMsg inquiryCmd
                , NoUpdate
                )


updateConfirmation : Model -> Confirmation.Msg -> ( Model, Cmd Msg, TacoUpdate )
updateConfirmation model confirmationMsg =
    case model.confirmationModel of
        Just confirmationModel ->
            let
                ( nextConfirmationModel, confirmationCmd ) =
                    Confirmation.update confirmationMsg confirmationModel
            in
                ( { model | confirmationModel = Just nextConfirmationModel }
                , Cmd.map ConfirmationMsg confirmationCmd
                , NoUpdate
                )

        Nothing ->
            ( model, Cmd.none, NoUpdate )


view : Taco -> Model -> Html Msg
view taco model =
    div []
        [ (case taco.item of
            Just item ->
                Item.view item (Slider.view (Slider.config { move = SliderAction }) model.sliderModel)

            Nothing ->
                text ""
          )
        , pageView taco model
        ]


pageView : Taco -> Model -> Html Msg
pageView taco model =
    case model.route of
        InquiryRoute ->
            Inquiry.view taco model.inquiryModel |> Html.map InquiryMsg

        ConfirmationRoute ->
            case model.confirmationModel of
                Just confirmationModel ->
                    Confirmation.view taco confirmationModel |> Html.map ConfirmationMsg

                Nothing ->
                    h1 [] [ text "404 :(" ]

        CompleteRoute ->
            case model.confirmationModel of
                Just confirmationModel ->
                    Complete.view taco confirmationModel.inquiry

                Nothing ->
                    h1 [] [ text "404 :(" ]

        _ ->
            h1 [] [ text "404 :(" ]
