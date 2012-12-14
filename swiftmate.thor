require 'childprocess'

class Swiftmate < Thor
  include Thor::Actions

  desc 'compile', 'compile the source and demo files'
  def compile
    puts 'Compile jquery.swiftmate.coffee once'
    run 'coffee -c -o demo/compiled src/jquery.swiftmate'

    puts 'Compile demo.coffee once'
    run 'coffee -c -o demo/compiled demo/src/demo'

    puts 'Compile demo.scss once'
    run 'sass demo/src/demo.scss:demo/compiled/demo.css'
  end

  desc 'watch', 'watch and recompile on file changes'
  def watch
    # Watch jquery.swiftmate.coffee
    p1 = ChildProcess.build('coffee -w -c -o demo/compiled src/jquery.swiftmate')
    p1.io.inherit!
    p1.start

    # Watch demo.coffee
    p2 = ChildProcess.build('coffee -w -c -o demo/compiled demo/src/demo')
    p2.io.inherit!
    p2.start

    # Watch demo.scss
    run 'sass --watch demo/src/demo.scss:demo/compiled/demo.css'
  end
end
