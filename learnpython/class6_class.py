
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
class Employee:
    '所有员工的基类'
    empCount = 0
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary
        Employee.empCount += 1
    
    def displayCount(self):
        print("Total Employee %d" % Employee.empCount)

    def displaySalary(self):
        print("the total of Employee salary %d" % (self.salary + self.salary))

    def displayEmployee(self):
        print("Name : ", self.name,  ", Salary: ", self.salary)
 
"创建 Employee 类的对象"
emp1 = Employee("Zara", 2000)
emp2 = Employee("Manni", 5000)
emp1.displayEmployee()
emp2.displayEmployee()
print("Total salary of Employee %d" % Employee.displaySalary)
print("Total Employee %d" % Employee.empCount)

