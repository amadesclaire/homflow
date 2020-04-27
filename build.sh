#!/bin/bash
case $# in
  2)
  echo "#!/bin/bash" >> "$1.sh" 
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  ;;
  3)
  echo "#!/bin/bash" >> "$1.sh"
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  echo "\$second=\$(qsub -W depend=afterok:\$first $3)" >> "$1.sh"
  echo "echo \$second" >> "$1.sh"
  ;;
  4)
  echo "#!/bin/bash" >> "$1.sh"
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  echo "\$second=\$(qsub -W depend=afterok:\$first $3)" >> "$1.sh"
  echo "echo \$second" >> "$1.sh"
  echo "\$third=\$(qsub -W depend=afterok:\$second $4)" >> "$1.sh"
  echo "echo \$third">> "$1.sh"
  ;;
  5)
  echo "#!/bin/bash" >> "$1.sh"
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  echo "\$second=\$(qsub -W depend=afterok:\$first $3)" >> "$1.sh"
  echo "echo \$second" >> "$1.sh"
  echo "\$third=\$(qsub -W depend=afterok:\$second $4)" >> "$1.sh"
  echo "echo \$third" >> "$1.sh"
  echo "\$fourth=\$(qsub -W depend=afterok:\$third $5)" >> "$1.sh"
  echo "echo \$fourth" >> "$1.sh"
  ;;
  6)
  echo "#!/bin/bash" >> "$1.sh"
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  echo "\$second=\$(qsub -W depend=afterok:\$first $3)" >> "$1.sh"
  echo "echo \$second" >> "$1.sh"
  echo "\$third=\$(qsub -W depend=afterok:\$second $4)" >> "$1.sh"
  echo "echo \$third" >> "$1.sh"
  echo "\$fourth=\$(qsub -W depend=afterok:\$third $5)" >> "$1.sh"
  echo "echo \$fourth" >> "$1.sh"
  echo "\$fifth=\$(qsub -W depend=afterok:\$fourth $6)" >> "$1.sh"
  echo "echo \$fifth" >> "$1.sh"
  ;;
  7)
  echo "#!/bin/bash" >> "$1.sh"
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  echo "\$second=\$(qsub -W depend=afterok:\$first $3)" >> "$1.sh"
  echo "echo \$second" >> "$1.sh"
  echo "\$third=\$(qsub -W depend=afterok:\$second $4)" >> "$1.sh"
  echo "echo \$third" >> "$1.sh"
  echo "\$fourth=\$(qsub -W depend=afterok:\$third $5)" >> "$1.sh"
  echo "echo \$fourth" >> "$1.sh"
  echo "\$fifth=\$(qsub -W depend=afterok:\$fourth $6)" >> "$1.sh"
  echo "echo \$fifth" >> "$1.sh"
  echo "\$sixth=\$(qsub -W depend=afterok:\$fifth $7)" >> "$1.sh"
  echo "echo \$sixth" >> "$1.sh"
  ;;
  8)
  echo "#!/bin/bash" >> "$1.sh"
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  echo "\$second=\$(qsub -W depend=afterok:\$first $3)" >> "$1.sh"
  echo "echo \$second" >> "$1.sh"
  echo "\$third=\$(qsub -W depend=afterok:\$second $4)" >> "$1.sh"
  echo "echo \$third" >> "$1.sh"
  echo "\$fourth=\$(qsub -W depend=afterok:\$third $5)" >> "$1.sh"
  echo "echo \$fourth" >> "$1.sh"
  echo "\$fifth=\$(qsub -W depend=afterok:\$fourth $6)" >> "$1.sh"
  echo "echo \$fifth" >> "$1.sh"
  echo "\$sixth=\$(qsub -W depend=afterok:\$fifth $7)" >> "$1.sh"
  echo "echo \$sixth" >> "$1.sh"
  echo "\$seventh=\$(qsub -W depend=afterok:\$sixth $8)" >> "$1.sh"
  echo "echo \$seventh" >> "$1.sh"
  ;;
  9)
  echo "#!/bin/bash" >> "$1.sh"
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  echo "\$second=\$(qsub -W depend=afterok:\$first $3)" >> "$1.sh"
  echo "echo \$second" >> "$1.sh"
  echo "\$third=\$(qsub -W depend=afterok:\$second $4)" >> "$1.sh"
  echo "echo \$third" >> "$1.sh"
  echo "\$fourth=\$(qsub -W depend=afterok:\$third $5)" >> "$1.sh"
  echo "echo \$fourth" >> "$1.sh"
  echo "\$fifth=\$(qsub -W depend=afterok:\$fourth $6)" >> "$1.sh"
  echo "echo \$fifth" >> "$1.sh"
  echo "\$sixth=\$(qsub -W depend=afterok:\$fifth $7)" >> "$1.sh"
  echo "echo \$sixth" >> "$1.sh"
  echo "\$seventh=\$(qsub -W depend=afterok:\$sixth $8)" >> "$1.sh"
  echo "echo \$seventh" >> "$1.sh"
  echo "\$eighth=\$(qsub -W depend=afterok:\$seventh $9)" >> "$1.sh"
  echo "echo \$eighth" >> "$1.sh"
  ;;
  9)
  echo "#!/bin/bash" >> "$1.sh"
  echo "\$first=\$(qsub $2)" >> "$1.sh"
  echo "echo \$first" >> "$1.sh"
  echo "\$second=\$(qsub -W depend=afterok:\$first $3)" >> "$1.sh"
  echo "echo \$second" >> "$1.sh"
  echo "\$third=\$(qsub -W depend=afterok:\$second $4)" >> "$1.sh"
  echo "echo \$third" >> "$1.sh"
  echo "\$fourth=\$(qsub -W depend=afterok:\$third $5)" >> "$1.sh"
  echo "echo \$fourth" >> "$1.sh"
  echo "\$fifth=\$(qsub -W depend=afterok:\$fourth $6)" >> "$1.sh"
  echo "echo \$fifth" >> "$1.sh"
  echo "\$sixth=\$(qsub -W depend=afterok:\$fifth $7)" >> "$1.sh"
  echo "echo \$sixth" >> "$1.sh"
  echo "\$seventh=\$(qsub -W depend=afterok:\$sixth $8)" >> "$1.sh"
  echo "echo \$seventh" >> "$1.sh"
  echo "\$eighth=\$(qsub -W depend=afterok:\$seventh $9)" >> "$1.sh"
  echo "echo \$eighth" >> "$1.sh"
  echo "\$ninth=\$(qsub -W depend=afterok:\$eighth $10)" >> "$1.sh"
  echo "echo \$ninth" >> "$1.sh"
  ;;
  *)
  echo "Error: This program can only handle 1-8 processes"
  ;;
esac