module Main exposing (..)

import Navigation exposing (Location)
import Time exposing (Time)
import Html exposing (..)
import RemoteData exposing (WebData, RemoteData(..))
import Routing.Router as Router
import Types exposing (Taco, TacoUpdate(..), Item(..), ItemDetail, Token)
import Views.Loading
import Views.Error
import Api.GetToken
import Api.GetItem


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { appState : AppState
    , location : Location
    }


type alias Flags =
    { itemID : Maybe String
    , currentTime : Time
    }


type AppState
    = NotReady Time
    | Ready Taco Router.Model
    | Error Time


type Msg
    = UrlChange Location
    | TimeChange Time
    | RouterMsg Router.Msg
    | HandleItemResponse String Token (WebData ItemDetail)
    | HandleTokenResponse (Maybe String) (WebData String)


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    ( { appState = NotReady flags.currentTime
      , location = location
      }
    , Api.GetToken.request |> RemoteData.sendRequest |> Cmd.map (HandleTokenResponse flags.itemID)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeChange time ->
            updateTime model time

        UrlChange location ->
            updateRouter { model | location = location } (Router.UrlChange location)

        RouterMsg routerMsg ->
            updateRouter model routerMsg

        HandleItemResponse itemID token webData ->
            updateItem model itemID token webData

        HandleTokenResponse maybeItemID webData ->
            updateToken model maybeItemID webData


updateTime : Model -> Time -> ( Model, Cmd Msg )
updateTime model time =
    case model.appState of
        NotReady _ ->
            { model | appState = NotReady time } ! []

        Ready taco routerModel ->
            { model | appState = Ready (updateTaco taco (UpdateTime time)) routerModel } ! []

        Error _ ->
            ( { model | appState = Error time }, Cmd.none )


updateRouter : Model -> Router.Msg -> ( Model, Cmd Msg )
updateRouter model routerMsg =
    case model.appState of
        Ready taco routerModel ->
            let
                nextTaco =
                    updateTaco taco tacoUpdate

                ( nextRouterModel, routerCmd, tacoUpdate ) =
                    Router.update routerMsg routerModel
            in
                { model | appState = Ready nextTaco nextRouterModel } ! [ Cmd.map RouterMsg routerCmd ]

        _ ->
            Debug.crash "Ooops. We got a sub-component message even though it wasn't supposed to be initialized?!?!?"


updateToken : Model -> Maybe String -> WebData Token -> ( Model, Cmd Msg )
updateToken model maybeItemID webData =
    case webData of
        Failure _ ->
            ( { model | appState = Error (getCurrentTime model) }, Cmd.none )

        Success token ->
            case maybeItemID of
                Just itemID ->
                    ( model
                    , Api.GetItem.request itemID |> RemoteData.sendRequest |> Cmd.map (HandleItemResponse itemID token)
                    )

                Nothing ->
                    let
                        ( routerModel, routerCmd ) =
                            Router.init model.location

                        currentTime =
                            getCurrentTime model
                    in
                        ( { model
                            | appState = Ready { currentTime = currentTime, item = Nothing, token = token } routerModel
                          }
                        , Cmd.map RouterMsg routerCmd
                        )

        _ ->
            ( model, Cmd.none )


updateItem : Model -> String -> Token -> WebData ItemDetail -> ( Model, Cmd Msg )
updateItem model itemID token webData =
    case Debug.log "updateItem" webData of
        Failure _ ->
            case model.appState of
                NotReady time ->
                    let
                        initTaco =
                            { currentTime = time
                            , item = Nothing
                            , token = token
                            }

                        ( initRouterModel, routerCmd ) =
                            Router.init model.location
                    in
                        ( { model | appState = Ready initTaco initRouterModel }
                        , Cmd.map RouterMsg routerCmd
                        )

                Ready taco routerModel ->
                    ( { model | appState = Error (getCurrentTime model) }, Cmd.none )

                Error time ->
                    ( { model | appState = Error time }, Cmd.none )

        Success itemDetail ->
            let
                item =
                    Item itemID (Just itemDetail)
            in
                case model.appState of
                    NotReady time ->
                        let
                            initTaco =
                                { currentTime = time
                                , item = Just item
                                , token = token
                                }

                            ( initRouterModel, routerCmd ) =
                                Router.init model.location
                        in
                            ( { model | appState = Ready initTaco initRouterModel }
                            , Cmd.map RouterMsg routerCmd
                            )

                    Ready taco routerModel ->
                        ( { model | appState = Ready (updateTaco taco (UpdateItem (Just item))) routerModel }
                        , Cmd.none
                        )

                    Error time ->
                        ( { model | appState = Error time }, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateTaco : Taco -> TacoUpdate -> Taco
updateTaco taco tacoUpdate =
    case tacoUpdate of
        UpdateTime time ->
            { taco | currentTime = time }

        UpdateItem maybeItem ->
            { taco | item = maybeItem }

        NoUpdate ->
            taco


getCurrentTime : Model -> Time
getCurrentTime model =
    case model.appState of
        NotReady time ->
            time

        Ready taco _ ->
            taco.currentTime

        Error time ->
            time


view : Model -> Html Msg
view model =
    case model.appState of
        Ready taco routerModel ->
            Router.view taco routerModel
                |> Html.map RouterMsg

        NotReady _ ->
            Views.Loading.view "読み込み中..."

        Error time ->
            Views.Error.view
                [ text "サーバーエラー" ]
