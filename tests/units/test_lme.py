import os
from unittest import mock

from fleks.util.lme import color_disabled, is_notebook


def test_is_notebook():
    assert not is_notebook()


def test_color_disabled():
    with mock.patch.dict(os.environ, {}):
        assert not color_disabled()
    with mock.patch.dict(os.environ, {"NO_COLOR": "1"}):
        assert color_disabled()
    with mock.patch.dict(os.environ, {"NO_COLOR": "yes"}):
        assert color_disabled()
