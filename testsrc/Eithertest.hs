{-# LANGUAGE CPP #-}

{- arch-tag: Data.Either.Utils tests
Copyright (C) 2004-2011 John Goerzen <jgoerzen@complete.org>

All rights reserved.

For license and copyright information, see the file LICENSE

-}

module Eithertest(tests) where
import Test.HUnit
import Data.Either.Utils
import Test.HUnit.Tools
import Control.Exception
import Control.Exception.ErrorCall.EqInstance

test_maybeToEither =
    let f msg inp exp = TestLabel msg $ TestCase $ assertEqual "" exp inp in
        [
         f "Nothing" (maybeToEither "error" (Nothing::Maybe String))
           (Left "error"),
         f "Nothing diff types" (maybeToEither "error" (Nothing::Maybe Int))
           (Left "error"),
         f "Just" (maybeToEither "error" (Just "good")) (Right "good"),
         f "Diff types" (maybeToEither "error" (Just (5::Int))) 
           (Right (5::Int))
        ]

test_forceEither =
    let f msg inp exp = TestLabel msg $ TestCase $ assertEqual "" exp inp in
    [
     f "Right" (forceEither ((Right "foo")::Either Int String)) "foo",
     TestLabel "Left" $ TestCase $ assertRaises ""
#if MIN_VERSION_base(4,9,0)
    -- FIXME: too fragile
       (ErrorCallWithLocation "\"wrong\"" "CallStack (from HasCallStack):\n  error, called at src/Data/Either/Utils.hs:52:24 in MissingH-1.4.1.1-inplace:Data.Either.Utils")
#else
       (ErrorCall "\"wrong\"")
#endif
           ("" @=? forceEither (Left "wrong"))
    ]

tests = TestList [TestLabel "test_maybeToEither" (TestList test_maybeToEither),
                  TestLabel "test_forceEither" (TestList test_forceEither)
                 ]

