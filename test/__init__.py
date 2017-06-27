import unittest2
from obstruction import Obstruct

value = {
  'foo': 'indeed',
  'bar': 'barbies',
  'some': {
    'nested': 'value'
  },
  'extra': 'awesome'
}

class DotPropsTest(unittest2.TestCase):
  def test_valuename(self):
    result = Obstruct({
      'foo': 'bar'
    }, value)

    self.assertEqual(result, {
      'foo': value['bar']
    })

  def test_true(self):
    result = Obstruct({
      'foo': True
    }, value)

    self.assertEqual(result, {
      'foo': value['foo']
    })

  def test_nested(self):
    result = Obstruct({
      'foo': 'some.nested'
    }, value)

    self.assertEqual(result, {
      'foo': value['some']['nested']
    })


if __name__ == '__main__':
  unittest.main()
