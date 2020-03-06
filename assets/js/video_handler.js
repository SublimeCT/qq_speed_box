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
        static IFRAME_SHEETS = `
            #video_container txpdiv.txp_tipbar { display: none; }
            .txp_recommend_content > .txp_btn.txp_btn_expand, .txp_tipbar, .txp_recommend.txp_recommend_pause.txp_recommend_s, txpdiv[data-role="hd-ad-adapter-interactivelayer"] { display: none; }
            @media screen and (orientation: portrait) {
                body, html { width : 100vmin; height : 100vmax; }
                body > video {
                    width : 100vmax;
                    height : 100vmin;
                    transform-origin: top left;
                    transform: rotate(90deg) translate(0,-100vmin);
                }
            }
            @media screen and (orientation: landscape) {
                html, body { width : 100vmax; height : 100vmin; }
                body > video {
                    width : 100vmax;
                    height : 100vmin;
                }
            }
        `
        static BBS_SHEETS = `
            #video_button {
                font-size: 45px;
                border-radius: 7px;
                margin-bottom: 35px;
            }
        `
        // static IFRAME_17173_SHEETS = `
        //     body {
        //         position: fixed;
        //         top: 0;
        //         left: 0;
        //         bottom: 0;
        //         right: 0;
        //         background: #000;
        //     }
        //     .wrap {
        //         position: fixed;
        //         top: 0;
        //         bottom: 0;
        //         transform-origin: 0 50%;
        //         transform: rotate(-90deg) translate(-50%, 50%);
        //     }
        // `
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
                // 跳转到视频页后加入自定义样式
                const sheet = document.createTextNode(VideoHandler.IFRAME_SHEETS)
                const el = document.createElement('style')
                el.id = 'toolkit-sheets'
                el.appendChild(sheet)
                document.getElementsByTagName('head')[0].appendChild(el)
                window._$VideoToolkit.loopRunUtil(() => {
                    // 播放视频
                    if (!window.player || typeof window.player.play !== 'function') return false
                    window.player.play()
                    const currentDefinition = document.querySelector('.txp_menuitem.txp_current')
                    const shdDefinition = document.querySelector('.txp_menuitem[data-definition=shd]')                    
                    if (!currentDefinition || !shdDefinition) return false; // 未找到清晰度选择器元素

                    // 检测是否存在广告, 若存在广告则加速跳过, PC 端可以用 [这个脚本](https://greasyfork.org/zh-CN/scripts/396106-qq%E9%A3%9E%E8%BD%A6%E5%AE%98%E6%96%B9%E8%AE%BA%E5%9D%9B%E8%A7%86%E9%A2%91%E5%A4%84%E7%90%86%E5%B7%A5%E5%85%B7-%E8%87%AA%E5%8A%A8%E8%AF%86%E5%88%AB%E8%A7%86%E9%A2%91%E5%B9%B6%E4%BB%A5-iframe-%E6%96%B9%E5%BC%8F%E5%8A%A0%E8%BD%BD)
                    const adExists = document.querySelector('.txp_ad_control:not(.txp_none)')
                    const videos = document.querySelectorAll('video')
                    if (adExists) {
                        for (const video of videos) {
                            video.playbackRate = 16
                            console.log(`[QQVideoADJump] 腾讯视频过滤日志 => 视频播放加速倍率: ${video.playbackRate}; 视频状态值: ${video.status}, 正在播放广告: ${adExists}`)
                        }
                    } else {
                        // ctx.log(`[QQVideoADJump] 已加速跳过广告, enjoy`)
                        if (videos && videos.length) videos.forEach(v => v.playbackRate = 1)
                    }

                    if (currentDefinition.innerText.indexOf('720P') === -1) { // 非 720P
                        setTimeout(() => shdDefinition.click()); // 切换到超清
                        return true
                    } else { // 已经切换到 720P
                        // 提取 mp4 格式的播放地址并通知 flutter 层
                        const video = document.querySelector('video')
                        if (video && video.src) {
                            console.log('提取成功: ' + video.src)
                            // 考虑到在原生平台的播放体验不佳, 最好的解决方案是在 web 页面播放
                            // location.href = 'https://v.qq.com/video_url/' + video.src
                            // window.player.pause()
                            const posterSheet = document.querySelector('.txp_poster').style.getPropertyValue('background-image')
                            const poster = posterSheet.match(/"(.*)"/)[1] || ''
                            this.generateVideo(video.src, poster)
                            return true
                        }
                    }
                }, undefined, 60)
            } else if (location.href.indexOf('https://v.qq.com/x/page/') === 0) {
                const matchRes = location.href.match(/https:\/\/v\.qq\.com\/x\/page\/([\d\w]+).htm.*/)
                if (matchRes && matchRes[1]) {
                    location.href = `https://v.qq.com/txp/iframe/player.html?vid=${matchRes[1]}`
                }
            } else if (location.href.indexOf('http://v.17173.com/player_ifrm2/') === 0) {
                // // 跳转到视频页后加入自定义样式
                // const sheet = document.createTextNode(VideoHandler.IFRAME_17173_SHEETS)
                // const el = document.createElement('style')
                // el.id = 'toolkit-sheets'
                // el.appendChild(sheet)
                // document.getElementsByTagName('head')[0].appendChild(el)
                // const wrap = document.querySelector('body > .wrap')
                // if (!wrap) return
            } else if (location.href.indexOf('https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=') === 0) {
                const contextDom = document.querySelector('.plc .pct')
                if (!contextDom) return
                const article = contextDom.innerText
                const urlMatchResult = article.match(/https:\/\/v\.qq\.com\/x\/page\/([\d\w]+).htm.*/) || article.match(/http:\/\/v\.qq\.com\/page\/.*\/([\d\w]+).htm.*/)
                const embed = document.querySelector('embed')
                const url = (embed && embed.src.indexOf('17173') > 0)
                    ? embed.src
                    : (urlMatchResult && urlMatchResult[0])
                url && this.showVideoButton(url)
                // location.href = url
            }
        }
        showVideoButton(url) {
            const btn = document.createElement('button')
            btn.id = 'video_button'
            btn.innerText = '🎬 播放视频 >>>'
            btn.addEventListener('click', evt => location.href = url)
            this._addSheets(VideoHandler.BBS_SHEETS)
            document.querySelector('.pcb').insertBefore(btn, document.querySelector('.pcb > div'))
        }
        generateVideo(url, poster) {
            const video = document.createElement('video')
            video.setAttribute('controls', '')
            video.setAttribute('src', url)
            video.setAttribute('poster', poster)
            document.body.innerHTML = ''
            document.body.appendChild(video)
        }
        _addSheets(sheets) {
            const sheet = document.createTextNode(sheets)
            const el = document.createElement('style')
            el.id = 'toolkit-sheets'
            el.appendChild(sheet)
            document.getElementsByTagName('head')[0].appendChild(el)
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