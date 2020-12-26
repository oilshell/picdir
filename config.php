<?php
// NOTE: The web server has to be configured to serve out of both of these
// dirs.
$upload_dir = getenv('IMAGEBIN_UPLOAD_DIR');
$cache_dir = getenv('IMAGEBIN_CACHE_DIR');

// TODO: Password here to avoid DoS with disk space, or do it on the server
// level?

//
// Free Functions for Testing
//

function sanitize($filename) {
  return preg_replace('/[^a-zA-Z0-9._-]/', '_', $filename);
}

function unique_id() {
  // This isn't foolproof, but it should be enough to discourage attackers from
  // trying to overwrite files.
  //
  // It also seems better than the builtin uniqid(), which can return the same
  // value in a tight loop.
  // https://www.php.net/manual/en/function.uniqid.php
  //
  // And the string is short (unlike an md5sum, which also isn't foolproof)
  return base_convert(time() + rand(), 10, 36);
}

?>
