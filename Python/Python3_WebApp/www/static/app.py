import logging; logging.basicConfig(level=logging.INFO)
import asyncio, os, json, time
from datetime import datetime

from aiohttp import web

from www.static import orm
from www.static.models import User, Blog, Comment

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


# 测试数据库插入
async def testSQL(name):
    logging.info('+++++++++++++++++++++')
    await orm.create_pool(user='root', password='root',database='webblog')

    user = User(name = name, email = 'test@email.com', passwd='1234567890', image='about:blank')

    await user.save()

    logging.info('--------------------')


loop = asyncio.get_event_loop()
loop.run_until_complete(init(loop))
logging.info('服务器已启动 http://127.0.0.1:9000')


co = testSQL('test')
myfuture1 = asyncio.ensure_future(testSQL('test'))
loop.run_until_complete(myfuture1)


loop.run_forever()





