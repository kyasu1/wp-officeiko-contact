module Views.ItemCss exposing (css)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import SharedStyles exposing (..)


css =
    (stylesheet << namespace inquiryNamespace.name)
        [ id ItemImage
            [ width (px 300)
            , border2 (px 1) solid
            , margin2 zero auto
            ]
        , class ItemLabel
            [ fontWeight bold
            ]
        , class ItemValue
            [ paddingLeft (px 24) ]
        ]
