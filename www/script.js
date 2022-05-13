$(document).ready(function () {
    $('button').on('click', function (e) {
    let buttonText = e.target.innerText;
    if (buttonText.includes('next page')) {
        window.scrollTo(0, 0);
    }
    });
});