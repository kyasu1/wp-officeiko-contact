module Validators exposing (validateInquiry)

import Form.Validate as Validate exposing (..)
import Types exposing (Inquiry, Gender(..))


validateInquiry : Validation String Inquiry
validateInquiry =
    Validate.succeed Inquiry
        |> andMap (field "name" (string |> withCustomError "お名前をご入力ください"))
        |> andMap (field "content" (string |> withCustomError "内容をご入力ください"))
        |> andMap (field "email" (email |> withCustomError "メールアドレスをご入力ください"))
        |> andMap
            (oneOf
                [ (field "email" email) |> andThen validateConfirmation
                , emptyString |> andThen validateConfirmation
                ]
            )
        |> andMap (field "phone" (oneOf [ emptyString |> Validate.map (\_ -> Nothing), string |> Validate.map Just ]))
        |> andMap (field "gender" (oneOf [ emptyString |> Validate.map (\_ -> Nothing), validateGender |> Validate.map Just ]))


validateConfirmation : String -> Validation String String
validateConfirmation email =
    field "emailConfirmation"
        (string
            |> withCustomError "メールアドレス確認をご入力ください"
            |> andThen
                (\confirmation ->
                    if email == confirmation then
                        succeed confirmation
                    else
                        fail (customError "上記と同じ内容をご入力ください")
                )
        )


validateGender : Validation String Gender
validateGender =
    customValidation
        string
        (\s ->
            case s of
                "男性" ->
                    Ok Male

                "女性" ->
                    Ok Female

                _ ->
                    Err (customError "性別をご入力ください")
        )
