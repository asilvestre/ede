-- Module      : Text.EDE.Internal.AST
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

-- | Abstract syntax smart constructors
module Text.EDE.Internal.AST
    ( module Text.EDE.Internal.AST
    , module Text.EDE.Internal.Types
    ) where

import Data.Text               (Text)
import Text.EDE.Internal.Types

evar :: a -> String -> Exp a
evar a = EVar a . Var

eabs :: a -> String -> Exp a -> Exp a
eabs a = EAbs a . Var

eapp :: a -> [Exp a] -> Exp a
eapp a = foldl1 (EApp a)

infixr 4 $$
($$) :: Exp Meta -> Exp Meta -> Exp Meta
a $$ b = eapp (meta a) [a, b]

einteger :: a -> Integer -> Exp a
einteger a = ELit a . LNum

etext :: a -> Text -> Exp a
etext a = ELit a . LText

ebool :: a -> Bool -> Exp a
ebool a = ELit a . LBool

tvar :: String -> Type a
tvar = TVar . TypeVar

infixr 4 -->
(-->) :: Type a -> Type a -> Type a
(-->) = TFun

exists :: String -> Type a
exists = TExists . TypeVar

tforall :: String -> Polytype -> Polytype
tforall = TForall . TypeVar

tforalls :: [TVar] -> Polytype -> Polytype
tforalls = flip (foldr TForall)

infixr 3 ==>
(==>) :: String -> Polytype -> Elem
v ==> a = CVar (Var v) a
