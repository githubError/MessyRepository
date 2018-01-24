import logging; logging.basicConfig(level=logging.INFO)
import asyncio, os, json, time
from datetime import datetime

from aiohttp import web

async def index(request):
    logging.info('--->')
    text = '<h1>Hello World! %s</h1>' % request.match_info['test']
    return web.Response(body=text.encode('utf-8'), headers={'content-type':'text/html'})

async def init(loop):
    app = web.Application(loop=loop)
    app.router.add_route('GET','/{test}',index)
    logging.info('+++++')
    srv = await loop.create_server(app.make_handler(), '127.0.0.1', 9000)
    return srv

loop = asyncio.get_event_loop()
loop.run_until_complete(init(loop))
logging.info('服务器已启动 http://127.0.0.1:9000')
loop.run_forever()