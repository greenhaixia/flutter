// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show SemanticsFlags;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'semantics_tester.dart';

void main() {
  testWidgets('Semantics 1', (WidgetTester tester) async {
    final SemanticsTester semantics = new SemanticsTester(tester);

    // smoketest
    await tester.pumpWidget(
      new Semantics(
        container: true,
        child: new Container(
          child: new Semantics(
            label: 'test1',
            textDirection: TextDirection.ltr,
            child: new Container(),
            selected: true,
          ),
        ),
      ),
    );

    expect(semantics, hasSemantics(new TestSemantics.root(
      children: <TestSemantics>[
        new TestSemantics.rootChild(
          id: 1,
          label: 'test1',
          rect: TestSemantics.fullScreen,
          flags: SemanticsFlags.isSelected.index,
        )
      ]
    )));

    // control for forking
    await tester.pumpWidget(
      new Semantics(
        container: true,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              height: 10.0,
              child: const Semantics(
                label: 'child1',
                textDirection: TextDirection.ltr,
                selected: true,
              ),
            ),
            new Container(
              height: 10.0,
              child: const IgnorePointer(
                ignoring: true,
                child: const Semantics(
                  label: 'child1',
                  textDirection: TextDirection.ltr,
                  selected: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    expect(semantics, hasSemantics(new TestSemantics.root(
      children: <TestSemantics>[
        new TestSemantics.rootChild(
          id: 1,
          label: 'child1',
          rect: TestSemantics.fullScreen,
          flags: SemanticsFlags.isSelected.index,
        )
      ],
    )));

    // forking semantics
    await tester.pumpWidget(
      new Semantics(
        container: true,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              height: 10.0,
              child: const Semantics(
                label: 'child1',
                textDirection: TextDirection.ltr,
                selected: true,
              ),
            ),
            new Container(
              height: 10.0,
              child: const IgnorePointer(
                ignoring: false,
                child: const Semantics(
                  label: 'child2',
                  textDirection: TextDirection.ltr,
                  selected: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    expect(semantics, hasSemantics(new TestSemantics.root(
      children: <TestSemantics>[
        new TestSemantics.rootChild(
          id: 1,
          rect: TestSemantics.fullScreen,
          children: <TestSemantics>[
            new TestSemantics(
              id: 2,
              label: 'child1',
              rect: new Rect.fromLTRB(0.0, 0.0, 800.0, 10.0),
              flags: SemanticsFlags.isSelected.index,
            ),
            new TestSemantics(
              id: 3,
              label: 'child2',
              rect: new Rect.fromLTRB(0.0, 0.0, 800.0, 10.0),
              flags: SemanticsFlags.isSelected.index,
            ),
          ],
        ),
      ],
    ), ignoreTransform: true));

    // toggle a branch off
    await tester.pumpWidget(
      new Semantics(
        container: true,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              height: 10.0,
              child: const Semantics(
                label: 'child1',
                textDirection: TextDirection.ltr,
                selected: true,
              ),
            ),
            new Container(
              height: 10.0,
              child: const IgnorePointer(
                ignoring: true,
                child: const Semantics(
                  label: 'child2',
                  textDirection: TextDirection.ltr,
                  selected: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    expect(semantics, hasSemantics(new TestSemantics.root(
      children: <TestSemantics>[
        new TestSemantics.rootChild(
          id: 1,
          label: 'child1',
          rect: TestSemantics.fullScreen,
          flags: SemanticsFlags.isSelected.index,
        )
      ],
    )));

    // toggle a branch back on
    await tester.pumpWidget(
      new Semantics(
        container: true,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              height: 10.0,
              child: const Semantics(
                label: 'child1',
                textDirection: TextDirection.ltr,
                selected: true,
              ),
            ),
            new Container(
              height: 10.0,
              child: const IgnorePointer(
                ignoring: false,
                child: const Semantics(
                  label: 'child2',
                  textDirection: TextDirection.ltr,
                  selected: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    expect(semantics, hasSemantics(new TestSemantics.root(
      children: <TestSemantics>[
        new TestSemantics.rootChild(
          id: 1,
          rect: TestSemantics.fullScreen,
          children: <TestSemantics>[
            new TestSemantics(
              id: 4,
              label: 'child1',
              rect: new Rect.fromLTRB(0.0, 0.0, 800.0, 10.0),
              flags: SemanticsFlags.isSelected.index,
            ),
            new TestSemantics(
              id: 3,
              label: 'child2',
              rect: new Rect.fromLTRB(0.0, 0.0, 800.0, 10.0),
              flags: SemanticsFlags.isSelected.index,
            ),
          ],
        ),
      ],
    ), ignoreTransform: true));

    semantics.dispose();
  });
}
