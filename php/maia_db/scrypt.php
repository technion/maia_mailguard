<?php

abstract class Password
{

    public static function hash($password)
    {
	if (function_exists('password_hash')) {
                $hash = password_hash($password, PASSWORD_DEFAULT);
        }
	else {
                $hash = crypt($password);
        }
	return $hash;
    }

    public static function check($password, $hash)
    {
        if (!$hash) {
            return false;
        }

        if (function_exists('password_verify')) {
                return password_verify($password, $hash);
        } 
	else {
                return (hash_equals($hash, crypt($password, $hash)));
        }

    }

}
