state_mine_test:
 module.run:
    - name: mine.send
    - func: cmd.run
    - kwargs:
        m_fun: foobar
        cmd: echo foobar
