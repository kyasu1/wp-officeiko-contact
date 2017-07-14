module Views.Item exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (Item(..))
import SharedStyles exposing (inquiryNamespace, CssIds(ItemImage), CssClasses(..))


id =
    inquiryNamespace.id


cs =
    inquiryNamespace.class


view : Item -> (List String -> Html msg) -> Html msg
view (Item itemID maybeItemDetail) slider =
    let
        classes =
            class "pa3 pa4-ns"
    in
        case maybeItemDetail of
            Just itemDetail ->
                div [ class "flex flex-column center flex-row-ns mw8-ns ph2-ns " ]
                    [ div [ class "w-50-ns justify-center", style [ ( "max-width", "600px" ) ] ]
                        [ slider itemDetail.images ]
                    , div [ class "w-50-ns pa3 justify-center flex flex-column" ]
                        [ div [ classes ]
                            [ itemLabel [ text "商品名" ]
                            , itemValue [ a [ href itemDetail.auctionItemUrl, target "_blank" ] [ text itemDetail.title ] ]
                            ]
                        , div [ classes ]
                            [ itemLabel [ text "価格（税別）" ]
                            , itemValue [ text <| (toString itemDetail.price) ++ "円" ]
                            ]
                        , div [ classes ]
                            [ itemLabel [ text "状態" ]
                            , itemValue [ text itemDetail.status ]
                            ]
                        ]
                    ]

            Nothing ->
                text "該当する商品がみつかりませんでした"


viewImage : String -> Html msg
viewImage image =
    figure [ class "image" ]
        [ img [ src image, id ItemImage ] []
        ]


itemLabel =
    h4 [ class "f4" ]


itemValue =
    div [ class "f4 mid-gray" ]
