;(function() {
    class VideoHandler {
        constructor() {
            console.log('[video_handler script]: init VideoHandler class')
            this.init()
        }
        async init() {
            // 判断是否需要跳转到指定页面
            await this.navitagorTo()
        }
        async navitagorTo() {
            if (location.href.indexOf('http://speed.qq.com/video3/detail.shtml') > 0) {
                console.log(searchObj)
            }
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