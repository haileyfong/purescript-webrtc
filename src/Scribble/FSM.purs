module Scribble.FSM where

foreign import kind Protocol
data Protocol (p :: Protocol) = Protocol

foreign import kind Role
data Role (r :: Role) = Role

-- | The symbol representation (name) of a role
class RoleName (r :: Role) (name :: Symbol) | r -> name

-- | A way of supplying the terminal/initial state for a given role
class Initial (r :: Role) a | r -> a
class Terminal (r :: Role) a | r -> a

-- | Transition from state `s` to `t` through sending a value of type `a`
class Send (r :: Role) s t a | a -> t, s -> r a

-- | Transition from state `s` to `t` through receiving a value of type `a`
class Receive (r :: Role) s t a | a -> t, s -> r a

-- | Branching (external choice) allows the other party to select from one or
-- | more next states to transition to. Therefore you must provide continuations 
-- | to handle all of the possibilities.
-- | Valid Scribble protocols guarentee that there is at most one terminal
-- | state, so all branches must either reach it or loop infinitely.
-- | In this case r is the role offering the choice and r' is the role choosing.
class Branch (r :: Role) (r' :: Role) s (ts :: # Type) | s -> ts r r'

-- | Selection (internal choice) is the dual of branching and allows you to
-- | select your next state. You distinguish your choice with a proxy containing
-- | the symbol of the next state.
-- | `s` and `ts` have the same meaning.
class Select (r :: Role) s (ts :: # Type) | s -> ts r

-- | Connect as role `r` to role `r'`
class Connect (r :: Role) (r' :: Role) s t | s -> r r' t
-- | Disconnect from role `r'`
class Disconnect (r :: Role) (r' :: Role) s t | s -> r r' t
-- | Accept a connection request from role `r'` to perform role `r`
class Accept (r :: Role) (r' :: Role) s t | s -> r r' t
