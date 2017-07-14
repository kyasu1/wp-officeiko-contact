module Routing.Helpers exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>))


type Route
    = InquiryRoute
    | ConfirmationRoute
    | CompleteRoute
    | NotFoundRoute


reverseRoute : Route -> String
reverseRoute route =
    case route of
        ConfirmationRoute ->
            "#/confirmation"

        CompleteRoute ->
            "#/complete"

        _ ->
            "#/"


routeParser : Url.Parser (Route -> a) a
routeParser =
    Url.oneOf
        [ Url.map InquiryRoute Url.top
        , Url.map ConfirmationRoute (Url.s "confirmation")
        , Url.map CompleteRoute (Url.s "complete")
        ]


parseLocation : Location -> Route
parseLocation location =
    location
        |> Url.parseHash routeParser
        |> Maybe.withDefault NotFoundRoute
