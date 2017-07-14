module Model exposing (Model, initialModel)

import Form exposing (Form)
import Types exposing (Item, Inquiry)
import Validators
import Inquiry


type alias Model =
    { itemId : Maybe String
    , loading : Bool
    , item : Maybe Item
    , inquiry : Maybe Inquiry
    , form : Form String Inquiry
    }


initialModel : Maybe String -> Model
initialModel itemId =
    { itemId = itemId
    , loading = True
    , item = Nothing
    , inquiry = Nothing
    , form = Form.initial Inquiry.initialFields Validators.validateInquiry
    }
