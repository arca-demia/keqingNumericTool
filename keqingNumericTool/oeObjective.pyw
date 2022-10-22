import sympy as sp

class objectiveMeta(object):
    # 작성중

    def __init__(*func):
        obj_functions
        num_funcs
        variables
        boundary
        discription

    @property
    def obj_functions(self):
        return self.obj_functions

    @obj_functions.setter
    def obj_functions(self, func):
        self.obj_functions = func
        # func(=목적 방정식)는 여러개일 수 있음
        # 여기에 num_funcs와 variables를 계산하도록 코드 넣기

    @property
    def num_funcs(self):
        return self.num_funcs

    @num_funcs.setter
    def num_funcs(self):
        pass#

    @property
    def variables(self):
        return self.variables

    @variables.setter
    def variables(self):
        pass#