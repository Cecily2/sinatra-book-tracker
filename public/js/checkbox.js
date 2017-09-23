
function toggleCheckbox() {
  var checked = document.getElementById("read").checked;
  if (checked) {
    document.getElementById("extraforms").style.display = "block";
  } else {
    document.getElementById("extraforms").style.display = "none";
  }
}

document.getElementById("read").onclick = toggleCheckbox;