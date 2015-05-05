{-# LANGUAGE OverloadedStrings #-}


module Main where


import Web.Spock.Safe


main :: IO ()
main = runSpock 9000 $ spockT id $
    get root $ text "Hello world!"
