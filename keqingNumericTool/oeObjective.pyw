import sympy as sp

class objectiveMeta(object):
    # �ۼ���

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
        # func(=���� ������)�� �������� �� ����
        # ���⿡ num_funcs�� variables�� ����ϵ��� �ڵ� �ֱ�

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