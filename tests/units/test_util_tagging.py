""" tests for util.tagging
"""

from fleks.util.tagging import tag_factory, taggers


def test_taggers_dynamic_attribute():
    my_tagger = taggers.my_tagger1

    @my_tagger.tag(foo="bar")
    def bar():
        pass

    assert "foo" in bar.my_tagger1
    assert "foo" in my_tagger.get_tags(bar)
    assert my_tagger.get_tags(bar)["foo"] == "bar"


def test_taggers_dynamic_get_item():
    my_tagger = taggers["my_tagger2"]

    @my_tagger.tag(foo="bar")
    @my_tagger.tag(zonk="bop")
    def bar():
        pass

    assert "foo" in bar.my_tagger2
    assert "foo" in my_tagger.get_tags(bar)
    assert my_tagger.get_tags(bar)["foo"] == "bar"
    assert my_tagger[bar] == my_tagger.get_tags(bar)
    assert my_tagger[bar]["zonk"] == "bop"


def test_tagger_call():
    my_tagger = taggers["my_tagger3"]

    @my_tagger(foo="bar")
    @my_tagger(bar="baz")
    def bar():
        pass

    assert "foo" in my_tagger[bar]
    assert my_tagger[bar]["bar"] == "baz"


def test_tag_factory():
    my_tagger = tag_factory("tag_registry1")

    @my_tagger.tag(foo="bar")
    def bar():
        pass

    assert "foo" in bar.tag_registry1
    assert "foo" in my_tagger.get_tags(bar)
    assert my_tagger.get_tags(bar)["foo"] == "bar"
