;(function() {
    class VideoHandler {
        constructor() {
            alert('hello ?')
        }
    }
    if (document.readyState === 'complete') {
        window._$VideoHandler = new VideoHandler()
    } else {
        window.addEventListener('DOMContentLoaded', evt => {
            window._$VideoHandler = new VideoHandler()
        })
    }
})();