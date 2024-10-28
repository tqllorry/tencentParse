# -*- encoding:utf-8 -*-
# 引入udf协议
from base_udf import BaseUDF

'''
这是udf的类
'''


class LengthTest(BaseUDF):
    def __init__(self):
        BaseUDF.__init__(self)

    '''
    这是udf的主要逻辑，注意data的类型是sql里传的字段类型，比如 select LengthTest(column1) as column2，如果column1是string类型，那么data就是string类型，eval返回的类型int为column2的类型
    '''

    def eval(self, data):
        return len(data)
