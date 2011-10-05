<?

$db = sqlite_open('scores.db', 0666, $error);
if (!$db) die ($error);

$query = "CREATE TABLE scores(" . 
       "name text, score int)";
$ok = @sqlite_exec($db, $query, $error);

if (!$ok && $error != "table scores already exists")
   die("Cannot execute query. $error");


$new_score = $_REQUEST["newscore"];
$new_name = $_REQUEST["newname"];
if ($new_score)
{
        $query = "INSERT INTO scores VALUES(\"" . $new_name . "\", " . $new_score . ")";
        $ok = sqlite_exec($db, $query, $error);
        if (!$ok) die("Cannot insert new score. " . $error);
}

$query = "SELECT name, score FROM scores ORDER BY score DESC LIMIT 10";
$result = sqlite_query($db, $query);
if ($result)
{
        while ($row = sqlite_fetch_array($result, SQLITE_ASSOC))
        {
                echo $row["name"] . "," . $row["score"] . "\n";
        }
}
sqlite_close($db);

?>