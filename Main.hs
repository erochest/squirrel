{-# LANGUAGE OverloadedStrings #-}


module Main where


import qualified Data.ByteString.Char8                as B8
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.Migration
import           System.Environment
import           Web.Spock.Safe
import           Web.Users.Postgresql                 ()
import           Web.Users.Types
import Database.PostgreSQL.Simple.Util


main :: IO ()
main = do
    conn <- connectPostgreSQL . B8.pack =<< getEnv "DB_CONNECTION"
    withTransaction conn $ runMigration $
        MigrationContext MigrationInitialization True conn
    runSpock 9000 $ spockT id $
        get root $ text "Hello world!"

unlessM :: Monad m => (m Bool) -> m () -> m ()
unlessM f m = do
    result <- f
    if result then return () else m

migrations :: Connection -> IO ()
migrations conn = withTransaction conn $ do
    runMigration $ MigrationContext MigrationInitialization True conn
    initUserBackend conn
