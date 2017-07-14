port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Views.ItemCss


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "item.css", Css.File.compile [ Views.ItemCss.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
