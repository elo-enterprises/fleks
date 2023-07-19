<!--- This is a markdown file.  Comments look like this --->
<table>
  <tr>
    <td colspan=2><strong>
    fleks
      </strong>&nbsp;&nbsp;&nbsp;&nbsp;
      <small><small>
      </small></small>
    </td>
  </tr>
  <tr>
    <td width=15%><img src=img/icon.png style="width:250px"></td>
    <td>
    Python application framework
    <br/><br/>
    <a href=https://pypi.python.org/pypi/fleks/><img src="https://img.shields.io/pypi/l/fleks.svg"></a>
    <a href=https://pypi.python.org/pypi/fleks/><img src="https://badge.fury.io/py/fleks.svg"></a>
    <a href="https://github.com/elo-enterprises/fleks/actions/workflows/python-test.yml"><img src="https://github.com/elo-enterprises/fleks/actions/workflows/python-test.yml/badge.svg"></a>    
    </td>
  </tr>
</table>

  * [Overview](#overview)
  * [Features](#features)
  * [Installation](#installation)
  * [Usage](#usage)
    * [Class-Properties](#class-properties)
    * [Typing helpers](#typing-helpers)
    * [Base-classes for Configuration](#base-classes-for-configuration)
    * [Base-classes for Configuration](#base-classes-for-configuration-1)


---------------------------------------------------------------------------------

## Overview

Application framework for python.  

(This is experimental; API-stability is not guaranteed.)

---------------------------------------------------------------------------------

## Features 

* CLI parsing with [click](https://click.palletsprojects.com/en/8.1.x/)
* Console output with [rich](https://rich.readthedocs.io/en/stable/index.html)
* Plugin Framework
* Exit-handlers, conventions for handling logging, etc

---------------------------------------------------------------------------------

## Installation

See [pypi](https://pypi.org/project/fleks/) for available releases.

```
pip install fleks
```

---------------------------------------------------------------------------------

## Usage

See also [the unit-tests](tests/units) for some examples of library usage.

### Class-Properties

```
import fleks 

class Test:
  @fleks.classproperty 
  def testing(kls):
    return 42

assert Test.testing==42
```

### Typing helpers

```
Placeholder
```

### Base-classes for Configuration

```
Placeholder
```

### Base-classes for Configuration

```
Placeholder
```

---------------------------------------------------------------------------------
