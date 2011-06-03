HOST="http://cookpad.local.com:3000"
OUTPUT="output/"

function render {
  phantomjs render.js $1 $2 320 1000
}

render $HOST'/?fmt=smt' $OUTPUT'cookpad_top.png'
render $HOST'/diary/1591399?fmt=smt' $OUTPUT'cookpad_diary.png'
render $HOST'/recipe/list/57172?fmt=smt' $OUTPUT'cookpad_recipe_list.png'
render $HOST'/recipe/692226?fmt=smt' $OUTPUT'cookpad_recipe.png'
render $HOST'/login?fmt=smt' $OUTPUT'cookpad_login.png'
render $HOST'/mobile?fmt=smt' $OUTPUT'cookpad_mobile.png'