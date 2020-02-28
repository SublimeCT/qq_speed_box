;(function() {
    window._$VideoToolkit = {
        async loopRunUtil(cb, timeout = 300, times = 30) {
            while (times--) {
                await window._$VideoToolkit.delay(timeout)
                const stop = await cb()
                if (stop) return
            }
        },
        delay(timeout) {
            return new Promise((resolve, _) => setTimeout(resolve, timeout))
        }
    }
    const handler = {
        qq: {

        }
    }
    class VideoHandler {
        constructor() {
            console.log('[video_handler script]: init VideoHandler class')
            this.init()
        }
        async init() {
            // 判断是否需要跳转到指定页面, 腾讯视频跳转到 iframe url 指定的页面, 在这里可以直接切换到 720P 清晰度
            await this.navitagorTo()
        }
        async navitagorTo() {
            if (location.href.indexOf('http://speed.qq.com/video3/detail.shtml') === 0 || location.href.indexOf('http://speed.qq.com/v/detail.shtml?') === 0) {
                window._$VideoToolkit.loopRunUtil(() => {
                    if (window.searchObj && window.searchObj.msg && window.searchObj.msg.sUrl) {
                        setTimeout(() => {
                            if (window.searchObj.msg.sVID) {
                                location.href = `https://v.qq.com/txp/iframe/player.html?vid=${window.searchObj.msg.sVID}`
                            } else {
                                console.warn('[video_handler script]: speed.qq.com/video3/detail.shtml URL 匹配失败 ...')
                            }
                        })
                        return true
                    }
                })
            } else if (location.href.indexOf('https://v.qq.com/txp/iframe/player.html') === 0) {
                window._$VideoToolkit.loopRunUtil(() => {
                    // 播放视频
                    if (!window.player || typeof window.player.play !== 'function') return false
                    window.player.play()
                    const currentDefinition = document.querySelector('.txp_menuitem.txp_current')
                    const shdDefinition = document.querySelector('.txp_menuitem[data-definition=shd]')
                    
                    if (!currentDefinition || !shdDefinition) return false; // 未找到清晰度选择器元素
                    if (currentDefinition.innerText.indexOf('720P') === -1) { // 非 720P
                        setTimeout(() => shdDefinition.click()); // 切换到超清
                        return true
                    } else { // 已经切换到 720P
                        // 提取 mp4 格式的播放地址并通知 flutter 层
                        const video = document.querySelector('video')
                        if (video && video.src) {
                            console.log('提取成功: ' + video.src)
                            return true
                        }
                    }
                }, undefined, 60)
            } else if (location.href.indexOf('https://v.qq.com/x/page/') === 0) {
                const matchRes = location.href.match(/https:\/\/v\.qq\.com\/x\/page\/([\d\w]+).htm.*/)
                if (matchRes && matchRes[1]) {
                    location.href = `https://v.qq.com/txp/iframe/player.html?vid=${matchRes[1]}`
                }
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